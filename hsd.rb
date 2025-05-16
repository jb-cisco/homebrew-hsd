class Hsd < Formula
  desc "hsd"
  version "1.1"

on_arm do
  url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.1/hsd-arm64"
  sha256 "54ac164c0d26234b53325241f00fcd64bd47a85a15cb3340af5c5e21d722e50b"
end

on_intel do
  url "https://github.com/jb-cisco/homebrew-hsd/releases/download/v1.1/hsd-amd64"
  sha256 "951e44d6eee7cc7a62ac7212e70461348269ca0bb7e322784c8c723a7860bcc8"
end

  def install
    bin.install "hsd"
  end
end