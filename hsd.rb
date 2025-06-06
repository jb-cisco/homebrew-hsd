class Hsd < Formula
  desc "hsd"
  version "1.37"

  on_macos do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.37/hsd-darwin-arm64"
      sha256 "cb40f29eee77acee9ea2d17ab8a385dc610ec94f8649340841c5935a440caca9"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.37/hsd-darwin-amd64"
      sha256 "9b5a9d1c109adb087b232feb62d979d34f54f958ae1ecaff3134dc05b4fcbd6b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.37/hsd-linux-arm64"
      sha256 "1c918b0541bac83622db7d4eae7d91a6e4621a0ba126dcfda7d438d130052707"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.37/hsd-linux-amd64"
      sha256 "4e8df1efc09990cf636e9184fac34022090df4c0ebe34905595e510b882e124b"
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