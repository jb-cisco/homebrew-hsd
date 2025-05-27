class Hsd < Formula
  desc "hsd"
  version "1.21"

  on_macos do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.21/hsd-darwin-arm64"
      sha256 "7f1f174a8c1b5a254a65e41bc7187fbad3b253e388e18b8e918fea9db96a6a90"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.21/hsd-darwin-amd64"
      sha256 "c28422de20b884a2b64be398d2a79addb38fb4d014d1b039e08a8c4a7e06775f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.21/hsd-linux-arm64"
      sha256 "cd247a6f3683bdd3d09a9c0765caecb7b5987a30fa17fa1aaa5d934bf91fd6bf"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.21/hsd-linux-amd64"
      sha256 "d4480a34c99f2bf8b813fc8f1cb158a327a3abe8849ff29387877d3a5516e3a8"
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