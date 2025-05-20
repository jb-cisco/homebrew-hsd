class Hsd < Formula
  desc "hsd"
  version "1.12"

  on_macos do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.12/hsd-darwin-arm64"
      sha256 "6cf257cf86d60be96f3def2e2e83c4d66ba0696faddd7f8f351aad571286a12d"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.12/hsd-darwin-amd64"
      sha256 "0537bf19a85c8d01c0d59d799ed845b99b489d8f1f96093fc4ff2f80b9502445"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.12/hsd-linux-arm64"
      sha256 "c8f363f016d94cf00e0fd18eadddaabaa804a56a591be93564886df165b66142"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.12/hsd-linux-amd64"
      sha256 "2ad3e165c3596b03ed8a0ef50bdcc13c0509bc7e3c015c9be5466e19021257b2"
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