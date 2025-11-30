// server.js - 简单的后端服务示例
// 这是一个教学示例，实际生产环境需要更多安全措施

const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const cors = require('cors');
const fs = require('fs');
const path = require('path');
const csv = require('csv-parser'); // 添加CSV解析库

const app = express();
const PORT = process.env.PORT || 3000;
const SECRET_KEY = process.env.JWT_SECRET || 'your-secret-key'; // 实际部署时应使用环境变量

// 中间件
app.use(cors());
app.use(express.json());

// 初始化数据库
const db = new sqlite3.Database('./users.db', (err) => {
  if (err) {
    console.error('数据库连接失败:', err.message);
  } else {
    console.log('已连接到SQLite数据库');
    
    // 创建用户表
    db.run(`CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      phone TEXT UNIQUE NOT NULL,
      password TEXT NOT NULL,
      username TEXT,
      is_student BOOLEAN DEFAULT FALSE,
      student_id TEXT,
      name TEXT,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )`, (err) => {
      if (err) {
        console.error('创建用户表失败:', err.message);
      } else {
        console.log('用户表已创建或已存在');
      }
    });
    
    // 创建验证码表
    db.run(`CREATE TABLE IF NOT EXISTS verification_codes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      phone TEXT NOT NULL,
      code TEXT NOT NULL,
      expires_at DATETIME NOT NULL,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )`, (err) => {
      if (err) {
        console.error('创建验证码表失败:', err.message);
      } else {
        console.log('验证码表已创建或已存在');
      }
    });
    
    // 创建帖子表
    db.run(`CREATE TABLE IF NOT EXISTS posts (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      title TEXT NOT NULL,
      content TEXT NOT NULL,
      tags TEXT,
      is_anonymous BOOLEAN DEFAULT FALSE,
      image_paths TEXT,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (user_id) REFERENCES users (id)
    )`, (err) => {
      if (err) {
        console.error('创建帖子表失败:', err.message);
      } else {
        console.log('帖子表已创建或已存在');
      }
    });
  }
});

// 读取CSV文件中的学生数据
const loadStudentDataFromCSV = () => {
  return new Promise((resolve, reject) => {
    const students = [];
    const csvFilePath = path.join(__dirname, 'student_data_simple.csv');
    
    // 检查CSV文件是否存在
    if (!fs.existsSync(csvFilePath)) {
      console.warn('学生数据CSV文件不存在，使用默认学生数据');
      resolve([
        { studentId: '20230001', name: '张三' },
        { studentId: '20230002', name: '李四' },
        { studentId: '20230003', name: '王五' }
      ]);
      return;
    }
    
    fs.createReadStream(csvFilePath)
      .pipe(csv())
      .on('data', (row) => {
        students.push({
          studentId: row.student_id,
          name: row.name
        });
      })
      .on('end', () => {
        console.log('成功加载学生数据，共', students.length, '条记录');
        resolve(students);
      })
      .on('error', (error) => {
        console.error('读取学生数据CSV文件出错:', error);
        reject(error);
      });
  });
};

// API状态检查路由
app.get('/api/status', (req, res) => {
  res.json({
    success: true,
    message: 'API服务运行正常',
    data: {
      timestamp: new Date().toISOString(),
      uptime: process.uptime()
    }
  });
});

// 生成JWT令牌
function generateToken(user) {
  return jwt.sign(
    { id: user.id, phone: user.phone },
    SECRET_KEY,
    { expiresIn: '24h' }
  );
}

// 验证JWT令牌中间件
function authenticateToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];
  
  if (!token) {
    return res.status(401).json({ 
      success: false, 
      message: '访问令牌缺失' 
    });
  }
  
  jwt.verify(token, SECRET_KEY, (err, user) => {
    if (err) {
      return res.status(403).json({ 
        success: false, 
        message: '令牌无效' 
      });
    }
    req.user = user;
    next();
  });
}

// 发送验证码接口
app.post('/api/auth/send-code', (req, res) => {
  const { phone } = req.body;
  
  if (!phone) {
    return res.status(400).json({ 
      success: false, 
      message: '手机号不能为空' 
    });
  }
  
  // 在测试模式下，使用固定验证码9999
  const code = '9999';
  
  // 设置5分钟后过期 (使用Unix时间戳)
  const expiresAt = Math.floor(Date.now() / 1000) + 5 * 60; // 5分钟有效期
  
  // 保存验证码到数据库
  const stmt = db.prepare(`INSERT OR REPLACE INTO verification_codes 
    (phone, code, expires_at) VALUES (?, ?, datetime(?, 'unixepoch'))`);
  stmt.run([phone, code, expiresAt], function(err) {
    if (err) {
      console.error('保存验证码失败:', err);
      return res.status(500).json({ 
        success: false, 
        message: '发送验证码失败' 
      });
    }
    
    // 实际项目中这里应该调用短信服务发送验证码
    console.log(`验证码 ${code} 已发送到 ${phone}`);
    
    res.json({ 
      success: true, 
      message: '验证码已发送（模拟）' 
    });
  });
  stmt.finalize();
});

// 验证验证码的函数
function verifyCode(db, phone, code, callback) {
  // 使用服务器当前时间检查验证码是否过期
  db.get(`SELECT * FROM verification_codes 
    WHERE phone = ? AND code = ? AND datetime('now') < expires_at`, 
    [phone, code], (err, row) => {
      if (err) {
        return callback(err, null);
      }
      callback(null, row);
    });
}

// 用户注册接口
app.post('/api/auth/register', async (req, res) => {
  const { phone, password, verificationCode } = req.body;
  
  // 验证必填字段
  if (!phone || !password || !verificationCode) {
    return res.status(400).json({ 
      success: false, 
      message: '手机号、密码和验证码不能为空' 
    });
  }
  
  // 验证密码强度
  if (password.length < 6) {
    return res.status(400).json({ 
      success: false, 
      message: '密码长度至少6位' 
    });
  }
  
  // 验证手机号格式
  const phoneRegex = /^1[3-9]\d{9}$/;
  if (!phoneRegex.test(phone)) {
    return res.status(400).json({ 
      success: false, 
      message: '手机号格式不正确' 
    });
  }
  
  // 在测试模式下，接受任何验证码（但为了测试流程，我们仍然检查数据库）
  // 如果是9999，则直接通过验证
  if (verificationCode === '9999') {
    // 检查手机号是否已注册
    db.get(`SELECT id FROM users WHERE phone = ?`, [phone], (err, row) => {
      if (err) {
        return res.status(500).json({ 
          success: false, 
          message: '注册失败' 
        });
      }
      
      if (row) {
        return res.status(400).json({ 
          success: false, 
          message: '该手机号已注册' 
        });
      }
      
      // 加密密码
      bcrypt.hash(password, 10, (err, hashedPassword) => {
        if (err) {
          return res.status(500).json({ 
            success: false, 
            message: '注册失败' 
          });
        }
        
        // 创建用户
        const stmt = db.prepare(`INSERT INTO users 
          (phone, password, username, is_student) VALUES (?, ?, ?, ?)`);
        stmt.run([phone, hashedPassword, `用户${phone.slice(-4)}`, false], function(err) {
          if (err) {
            return res.status(500).json({ 
              success: false, 
              message: '注册失败' 
            });
          }
          
          // 获取创建的用户信息
          db.get(`SELECT id, phone, username, is_student, created_at FROM users WHERE id = ?`, 
            [this.lastID], (err, user) => {
              if (err) {
                return res.status(500).json({ 
                  success: false, 
                  message: '注册失败' 
                });
              }
              
              // 生成JWT令牌
              const token = generateToken(user);
              
              res.json({
                success: true,
                message: '注册成功',
                data: {
                  user,
                  token
                }
              });
            });
        });
        stmt.finalize();
      });
    });
  } else {
    // 对于非测试验证码，使用传统验证方法
    verifyCode(db, phone, verificationCode, (err, row) => {
      if (err) {
        console.error('验证验证码时出错:', err);
        return res.status(500).json({ 
          success: false, 
          message: '验证失败' 
        });
      }
      
      if (!row) {
        return res.status(400).json({ 
          success: false, 
          message: '验证码无效或已过期' 
        });
      }
      
      // 检查手机号是否已注册
      db.get(`SELECT id FROM users WHERE phone = ?`, [phone], (err, row) => {
        if (err) {
          return res.status(500).json({ 
            success: false, 
            message: '注册失败' 
          });
        }
        
        if (row) {
          return res.status(400).json({ 
            success: false, 
            message: '该手机号已注册' 
          });
        }
        
        // 加密密码
        bcrypt.hash(password, 10, (err, hashedPassword) => {
          if (err) {
            return res.status(500).json({ 
              success: false, 
              message: '注册失败' 
            });
          }
          
          // 创建用户
          const stmt = db.prepare(`INSERT INTO users 
            (phone, password, username, is_student) VALUES (?, ?, ?, ?)`);
          stmt.run([phone, hashedPassword, `用户${phone.slice(-4)}`, false], function(err) {
            if (err) {
              return res.status(500).json({ 
                success: false, 
                message: '注册失败' 
              });
            }
            
            // 获取创建的用户信息
            db.get(`SELECT id, phone, username, is_student, created_at FROM users WHERE id = ?`, 
              [this.lastID], (err, user) => {
                if (err) {
                  return res.status(500).json({ 
                    success: false, 
                    message: '注册失败' 
                  });
                }
                
                // 生成JWT令牌
                const token = generateToken(user);
                
                res.json({
                  success: true,
                  message: '注册成功',
                  data: {
                    user,
                    token
                  }
                });
              });
          });
          stmt.finalize();
        });
      });
    });
  }
});

// 用户登录接口
app.post('/api/auth/login', (req, res) => {
  const { phone, password } = req.body;
  
  // 验证必填字段
  if (!phone || !password) {
    return res.status(400).json({ 
      success: false, 
      message: '手机号和密码不能为空' 
    });
  }
  
  // 查找用户
  db.get(`SELECT id, phone, password, username, is_student, created_at FROM users WHERE phone = ?`, 
    [phone], (err, user) => {
      if (err) {
        return res.status(500).json({ 
          success: false, 
          message: '登录失败' 
        });
      }
      
      if (!user) {
        return res.status(400).json({ 
          success: false, 
          message: '手机号或密码错误' 
        });
      }
      
      // 验证密码
      bcrypt.compare(password, user.password, (err, result) => {
        if (err || !result) {
          return res.status(400).json({ 
            success: false, 
            message: '手机号或密码错误' 
          });
        }
        
        // 移除密码字段
        const { password, ...userInfo } = user;
        
        // 生成JWT令牌
        const token = generateToken(userInfo);
        
        res.json({
          success: true,
          message: '登录成功',
          data: {
            user: userInfo,
            token
          }
        });
      });
  });
});

// 获取用户信息接口
app.get('/api/user/profile', authenticateToken, (req, res) => {
  db.get(`SELECT id, phone, username, is_student, student_id, name, created_at FROM users WHERE id = ?`, 
    [req.user.id], (err, user) => {
      if (err) {
        return res.status(500).json({ 
          success: false, 
          message: '获取用户信息失败' 
        });
      }
      
      if (!user) {
        return res.status(404).json({ 
          success: false, 
          message: '用户不存在' 
        });
      }
      
      res.json({
        success: true,
        data: { user }
      });
  });
});

// 申请学生认证接口
app.post('/api/user/verify-student', authenticateToken, async (req, res) => {
  const { studentId, name } = req.body;
  
  // 验证必填字段
  if (!studentId || !name) {
    return res.status(400).json({ 
      success: false, 
      message: '学号和姓名不能为空' 
    });
  }
  
  try {
    // 从CSV文件加载学生数据
    const validStudents = await loadStudentDataFromCSV();
    
    // 验证学生信息（检查学号和姓名是否匹配）
    const isValidStudent = validStudents.some(student => 
      student.studentId === studentId && student.name === name
    );
    
    if (!isValidStudent) {
      return res.status(400).json({ 
        success: false, 
        message: '学号或姓名不正确' 
      });
    }
    
    // 更新用户信息并设置为学生
    db.run(`UPDATE users SET is_student = ?, student_id = ?, name = ? WHERE id = ?`, 
      [true, studentId, name, req.user.id], function(err) {
        if (err) {
          return res.status(500).json({ 
            success: false, 
            message: '认证申请失败' 
          });
        }
        
        if (this.changes === 0) {
          return res.status(404).json({ 
            success: false, 
            message: '用户不存在' 
          });
        }
        
        res.json({
          success: true,
          message: '学生认证成功'
        });
    });
  } catch (error) {
    console.error('学生认证过程中出错:', error);
    return res.status(500).json({ 
      success: false, 
      message: '认证过程中发生错误' 
    });
  }
});

// 用户登出接口
app.post('/api/auth/logout', authenticateToken, (req, res) => {
  // JWT令牌由前端销毁，后端无需特殊处理
  // 实际项目中可以加入黑名单机制
  
  res.json({
    success: true,
    message: '登出成功'
  });
});

// 发布帖子接口
app.post('/api/posts', authenticateToken, (req, res) => {
  const { userId, title, content, tags, isAnonymous, imagePaths } = req.body;
  
  // 验证必填字段
  if (!title || !content) {
    return res.status(400).json({
      success: false,
      message: '标题和内容不能为空'
    });
  }
  
  // 检查用户是否有权限发布帖子（是否为认证学生）
  db.get(`SELECT is_student FROM users WHERE id = ?`, [req.user.id], (err, user) => {
    if (err) {
      return res.status(500).json({
        success: false,
        message: '发布帖子失败'
      });
    }
    
    if (!user) {
      return res.status(404).json({
        success: false,
        message: '用户不存在'
      });
    }
    
    if (!user.is_student) {
      return res.status(403).json({
        success: false,
        message: '只有认证学生才能发布帖子'
      });
    }
    
    // 插入帖子到数据库
    const stmt = db.prepare(`INSERT INTO posts 
      (user_id, title, content, tags, is_anonymous, image_paths) 
      VALUES (?, ?, ?, ?, ?, ?)`);
    stmt.run([
      req.user.id, 
      title, 
      content, 
      JSON.stringify(tags), 
      isAnonymous ? 1 : 0, 
      JSON.stringify(imagePaths)
    ], function(err) {
      if (err) {
        return res.status(500).json({
          success: false,
          message: '发布帖子失败'
        });
      }
      
      res.status(201).json({
        success: true,
        message: '帖子发布成功',
        data: {
          postId: this.lastID
        }
      });
    });
    stmt.finalize();
  });
});

// 获取帖子列表接口
app.get('/api/posts', (req, res) => {
  const page = parseInt(req.query.page) || 1;
  const limit = parseInt(req.query.limit) || 10;
  const offset = (page - 1) * limit;
  
  // 查询帖子总数
  db.get(`SELECT COUNT(*) as total FROM posts`, (err, countResult) => {
    if (err) {
      return res.status(500).json({
        success: false,
        message: '获取帖子失败'
      });
    }
    
    const total = countResult.total;
    const totalPages = Math.ceil(total / limit);
    
    // 查询帖子列表，包含用户信息
    db.all(`
      SELECT p.*, u.username, u.name as user_real_name, u.is_student as user_is_student
      FROM posts p 
      JOIN users u ON p.user_id = u.id 
      ORDER BY p.created_at DESC 
      LIMIT ? OFFSET ?`,
      [limit, offset],
      (err, rows) => {
        if (err) {
          return res.status(500).json({
            success: false,
            message: '获取帖子失败'
          });
        }
        
        // 处理匿名帖子
        const posts = rows.map(post => {
          if (post.is_anonymous) {
            return {
              ...post,
              user_id: null,
              username: '匿名用户',
              user_real_name: null,
              user_is_student: null
            };
          }
          return post;
        });
        
        res.json({
          success: true,
          data: {
            posts,
            pagination: {
              currentPage: page,
              totalPages,
              totalPosts: total,
              hasNextPage: page < totalPages,
              hasPrevPage: page > 1
            }
          }
        });
      }
    );
  });
});

// 获取单个帖子详情接口
app.get('/api/posts/:id', (req, res) => {
  const postId = req.params.id;
  
  db.get(`
    SELECT p.*, u.username, u.name as user_real_name, u.is_student as user_is_student
    FROM posts p 
    JOIN users u ON p.user_id = u.id 
    WHERE p.id = ?`,
    [postId],
    (err, post) => {
      if (err) {
        return res.status(500).json({
          success: false,
          message: '获取帖子失败'
        });
      }
      
      if (!post) {
        return res.status(404).json({
          success: false,
          message: '帖子不存在'
        });
      }
      
      // 处理匿名帖子
      if (post.is_anonymous) {
        post.user_id = null;
        post.username = '匿名用户';
        post.user_real_name = null;
        post.user_is_student = null;
      }
      
      res.json({
        success: true,
        data: { post }
      });
  });
});

// 启动服务器
app.listen(PORT, '0.0.0.0', () => {
  console.log(`服务器运行在端口 ${PORT}`);
});

module.exports = app;