#!/bin/bash
echo "Panda Panel VPS Kurulumu Basliyor..."

# Node.js ve Git Kurulumu
apt-get update
apt-get install -y nodejs npm git

# Klasör Hazırla
mkdir -p /root/panda-panel
cd /root/panda-panel

# Sunucu Kodunu Oluştur
cat <<EOF > server.js
const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const app = express();
app.use(cors());
app.use(express.json());

// Senin MongoDB adresin ve şifren
const mongoURI = "mongodb+srv://Pandapanel:DPvoNWbCjNorUKL5@cluster0.o9vglrq.mongodb.net/panda-panel?retryWrites=true&w=majority";

mongoose.connect(mongoURI).then(() => console.log("✅ MongoDB Baglandi"));

const User = mongoose.model("User", { username: String });

app.get("/users", async (req, res) => {
    const users = await User.find();
    res.json(users);
});

app.listen(3000, "0.0.0.0", () => console.log("🚀 Sunucu Aktif!"));
EOF

# Gerekli Paketleri Kur
npm init -y
npm install express mongoose cors

# PM2 ile Sürekli Çalıştır
npm install pm2 -g
pm2 start server.js
pm2 save
pm2 startup

echo "✅ Kurulum Tamamlandi!"
