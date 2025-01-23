# 🎯 VisionTrick v1.1

**VisionTrick** is a powerful and versatile phishing simulation tool designed to capture IP addresses and images from targets. With seamless Telegram integration, it sends captured data directly to your Telegram channel, making it an essential tool for penetration testers, security researchers, and ethical hackers.

---

## 🌟 Features

- **🌐 IP Address Capture**: Automatically captures the IP address of the target when they open the phishing link.
- **📸 Image Capture**: Captures images from the target's device (if they grant access).
- **🤖 Telegram Integration**: Sends captured images directly to your Telegram channel using a bot.
- **🎭 Multiple Templates**: Offers customizable phishing simulation templates:
  - 🎉 Festival Wishing
  - 📺 Live YouTube TV
  - 🖥️ Online Meeting
- **🔗 Ngrok Integration**: Generates secure tunneling links for hosting phishing pages.
- **📱 Cross-Platform**: Works on Linux, macOS, and Android (via Termux).

---

## 🛠️ Prerequisites

Before using VisionTrick, ensure you have the following installed:

- **PHP** (for local server hosting)
- **Python3** (for Telegram integration)
- **curl**, **wget**, and **unzip** (for downloading dependencies)
- **Ngrok** (for tunneling; the script will download it automatically if not present)

---

## 🚀 Setup Instructions

### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/visiontrick.git
cd visiontrick
```

---

### 2. Make the Script Executable
```bash
chmod +x vision_trick.sh
```

---

### 3. Set Up Telegram Bot
   
Create a new bot on Telegram and copy its bot token.
Add the bot to your Telegram channel and make it an admin.
Copy the channel Id.

---

### 4. Run the Script
```bash
./vision_trick.sh
```

## ⚠️ Disclaimer
This tool is intended for educational and ethical purposes only. The developers are not responsible for any misuse of this tool. Always ensure you have proper authorization before using VisionTrick on any network or individual.

---

### 💡 Credits

0xgh0stri13y &
0xtor.exe
