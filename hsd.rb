class Hsd < Formula
  desc "hsd"
  version "1.10"

  on_macos do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.10/hsd-darwin-arm64"
      sha256 "c9ca881d312863215a68e3131490d7dbbc99090ae4e711e85991ebf65e08e01b"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.10/hsd-darwin-amd64"
      sha256 "89637602031a16f9890fe62e73a98c16a352ae362b640b8ab6532c23ec2f2093"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.10/hsd-linux-arm64"
      sha256 "d98b3d795fdc775e81e18de94372e4ebf05d6d5c071e681f6ffbd647535a1f10"
    end
    
    on_intel do
      url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.10/hsd-linux-amd64"
      sha256 "d1923ff2d89de20ed5da7f54a2d332d385cdf7fe04dfdaf1212e841bcdd8b9a3"
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