class Hsd < Formula
  desc "hsd"
  version "1.18"

  on_macos do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.18/hsd-darwin-arm64"
      sha256 "749dd79cfc48d80fe605331c57e61aed43c2f12192339be773b3abe758f04400"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.18/hsd-darwin-amd64"
      sha256 "3cfec2ce26a5e829607190be34394100a078e4789ca8d458fe2268150bbb7b4f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.18/hsd-linux-arm64"
      sha256 "5a729d45a5912724c0900fb625a824cf52b96dbb1712e2be42dea3d9e64541e6"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.18/hsd-linux-amd64"
      sha256 "7299930e929e7c473bc62ba9b5640a414e4ce36630e111bf98c35ebba6b4dd64"
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