class Hsd < Formula
  desc "hsd"
  version "1.44"

  on_macos do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.44/hsd-darwin-arm64"
      sha256 "6ec01868c670a61d1fbcf3ac260d595d26ccde451d632d1255e8baa26974e1c0"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.44/hsd-darwin-amd64"
      sha256 "bcf564debf875a9ca4b27fe78e4104c6bc3587ab0ae0b8e93ad96a7b3ba238df"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.44/hsd-linux-arm64"
      sha256 "870ba4d71f708e912c16d793a8cfc354698eb03b9596cc9a502d9aaf459cb1fb"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.44/hsd-linux-amd64"
      sha256 "3fefd3b2a455dd52c68f06c32396de29da666a4aa8c0924e4def962a0ad7c428"
    end
  end

  def install
    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    bin.install "hsd-#{os}-#{arch}" => "hsd"
  end

  def post_install
    config_path = File.expand_path("~/.hsd")
    unless File.exist?(config_path)
      opoo "No existing hsd config found. Run: hsd config init"
    end

    if OS.mac?
      recommended = ["awscli", "kubernetes-cli", "helm"]
    else
      # For Linux, the package names might be different
      recommended = ["awscli", "kubernetes-cli", "helm"]
    end

    missing = recommended.reject do |pkg|
      quiet_system "brew", "list", "--formula", pkg
    end
    
    unless missing.empty?
      ohai "Recommended Homebrew packages missing: #{missing.join(', ')}"
      ohai "You can install them with:"
      ohai "  brew install #{missing.join(' ')}"
    end
  end
end