#!/usr/bin/env node

// postinstall 脚本 - 验证安装是否成功

const path = require("path")
const fs = require("fs")

const PLATFORMS = {
  "darwin-arm64": "senlinlon-cli-darwin-arm64",
  "darwin-x64": "senlinlon-cli-darwin-x64",
  "linux-arm64": "senlinlon-cli-linux-arm64",
  "linux-x64": "senlinlon-cli-linux-x64",
  "win32-x64": "senlinlon-cli-windows-x64",
}

function main() {
  const platform = process.platform
  const arch = process.arch
  const key = `${platform}-${arch}`

  const packageName = PLATFORMS[key]
  if (!packageName) {
    console.warn(`⚠️  警告: 当前平台 ${platform}-${arch} 可能不受支持`)
    console.warn(`   支持的平台: ${Object.keys(PLATFORMS).join(", ")}`)
    return
  }

  try {
    require.resolve(`${packageName}/package.json`)
    console.log(`✅ Senlinlon 安装成功！`)
    console.log(`   运行 'senlinlon --version' 查看版本`)
    console.log(`   运行 'senlinlon --help' 查看帮助`)
  } catch (e) {
    console.warn(`⚠️  警告: 平台包 ${packageName} 未能安装`)
    console.warn(`   这可能是因为 npm 的 optionalDependencies 安装失败`)
    console.warn(`   请尝试: npm install -g senlinlon-cli --ignore-scripts && npm install -g ${packageName}`)
  }
}

main()
