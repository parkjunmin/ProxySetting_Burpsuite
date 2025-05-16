# Chrome Burp Proxy Launcher

<div align="center">

![Version](https://img.shields.io/badge/version-1.2-blue.svg)
![Platform](https://img.shields.io/badge/platform-Windows-lightgrey.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

</div>

A Windows batch script that automatically configures and launches Chrome with Burp Suite proxy for web application security testing.

## 🚀 Features

- **One-Click Setup**: Automatically configures Chrome with Burp Suite proxy
- **Isolated Profiles**: Creates a fresh Chrome profile for each session
- **Auto-Cleanup**: Removes old Chrome profiles to save disk space
- **System Proxy Management**: Easily toggle proxy settings on/off
- **Custom Port Configuration**: Change the proxy port as needed
- **Auto-Detection**: Automatically finds and launches Burp Suite

## 📋 Prerequisites

- Windows operating system
- Google Chrome installed
- Burp Suite Community/Professional installed

## 🔧 Installation

1. Clone this repository or download the script:
```bash
git clone https://github.com/parkjunmin/ProxySetting_Burpsuite.git
```

2. No additional installation is required - just run the batch file!

## 📖 Usage

### Running the Script

Simply double-click the `.bat` file or run it from the command prompt.

### Menu Options

The launcher provides three main options:

```
==================================================
     Chrome Burp Proxy Launcher v1.2 by DBDROP
     (swm5048@naver.com)
==================================================

 외부 IP: 203.0.113.1
 내부 IP: 192.168.1.5
 현재 프록시 포트: 8080

 시스템 프록시 상태: 비활성화

--------------------------------------------------
 1. Chrome 실행 (Burp Proxy 사용)
 2. 프록시 설정 해제
 3. 프록시 포트 변경
--------------------------------------------------
```

#### Option 1: Launch Chrome with Burp Proxy

Selecting this option will:
- Check if Burp Suite is running and launch it if not
- Configure system proxy to 127.0.0.1:8080 (or your custom port)
- Clean up any previous Chrome profiles
- Create a fresh isolated Chrome profile
- Launch Chrome configured to use Burp Suite as a proxy

#### Option 2: Disable Proxy Settings

This option disables the system-wide proxy configuration.

#### Option 3: Change Proxy Port

Change the port used for the proxy connection (if you need a different port than the default 8080).

## 💡 How It Works

1. The script searches for Burp Suite in common installation locations
2. Creates a fresh Chrome profile in C:\Temp\ChromeBurpProfile-[random]
3. Configures system proxy settings to route through Burp Suite
4. Launches Chrome with special flags for proxy configuration
5. On subsequent runs, cleans up old profile directories

## ⚠️ Troubleshooting

### No Traffic in Burp Suite

Make sure:
1. Burp Suite Proxy listener is configured for the correct port (default: 8080)
2. "Intercept is on" is enabled in the Intercept tab
3. Chrome is actually using the configured proxy (check Chrome settings)

### Chrome Profile Creation Errors

If Chrome complains about data directory creation failures:
- Make sure C:\Temp directory exists and is writable
- Try running the script as Administrator

## 📜 License

This project is available under the MIT License - see the LICENSE file for details.

## 👨‍💻 Author

**DBDROP** - [GitHub Profile](https://github.com/parkjunmin)

Contact: swm5048@naver.com

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check [issues page](https://github.com/parkjunmin/ProxySetting_Burpsuite/issues).

## ⭐ Show your support

If you find this tool useful, please give it a star on GitHub!
