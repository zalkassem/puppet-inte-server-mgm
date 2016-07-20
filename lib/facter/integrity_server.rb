Facter.add(:integrity_server) do
  setcode do
    server_version = nil
    if output = Facter::Util::Resolution.exec('rpm -q --queryformat "%{Version}" ptc-integrity-server')
      server_version = output if /^[0-9]+.[0-9]+$/.match(output)
    end
  end
end
