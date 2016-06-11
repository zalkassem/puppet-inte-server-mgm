Puppet::Type.newtype(:mksgroup) do
  @doc = "Manage a Group for the PTC Integrity Server"

  ensurable

  newparam(:name, :namevar => true) do
    desc "The name of the group."
  end

  newproperty(:desc) do
    desc "Description of the group"
  end

  newproperty(:members, :array_matching => :all) do
    desc "List of users belong to the group"
    def insync?(is)
      is.sort == should.sort
    end
  end

  newproperty(:groups, :array_matching => :all) do
    desc "List of groups belong to the group"
    def insync?(is)
      is.sort == should.sort
    end
  end

end
