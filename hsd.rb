class Hsd < Formula
  desc "hsd"
  version "1.22"

  on_macos do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.22/hsd-darwin-arm64"
      sha256 "49c7da02026c427aaf645feecc0758ec2bb4323b0afbf6e1d61b80436dd6d2fb"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.22/hsd-darwin-amd64"
      sha256 "58ebedbd18bb786d4e81669daf5b9068fbd6770b3e0d32172108639baa2d9542"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.22/hsd-linux-arm64"
      sha256 "54a7e44792f3ce277a69de34f8b65db18e3d5a3ca967853e30fe38d7d65ffe92"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.22/hsd-linux-amd64"
      sha256 "ba16432cdd1f48222fbf6f55b9d71f10cfef504402c73f8bcef643057efa838d"
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