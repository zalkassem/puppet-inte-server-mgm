Puppet::Type.type(:mksgroup).provide(:integrity) do
  desc ''

  commands :integrity => '/opt/integrity/client/bin/integrity'

  mk_resource_methods

  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  def self.get_mksgroup_list
    output = Puppet::Util::Execution.execute(
      [ command(:integrity), 'mksdomaingroups',
        '--hostname=localhost',
        '--port=7001',
        '--user=fsaadmin',
        '--password=200MKS9'
      ],
      :failonfail => true,
      :uid => 'mks',
      :custom_environment => {
        'PATH' => '/opt/integrity/client/bin:/bin:/usr/bin',
        'MKS_IC_INSTANCE_DIR' => '/opt/integrity/client'
      })
    return false unless output.exitstatus
    output.sort
  end

  def self.get_mksgroup_properties(group)
    output = Puppet::Util::Execution.execute(
      [ command(:integrity), 'viewmksdomaingroup',
        '--hostname=localhost',
        '--port=7001',
        '--user=fsaadmin',
        '--password=200MKS9',
        "#{group}"
      ],
      :failonfail => true,
      :uid => 'mks',
      :custom_environment => {
        'PATH' => '/opt/integrity/client/bin:/bin:/usr/bin',
        'MKS_IC_INSTANCE_DIR' => '/opt/integrity/client'
      })
    return false unless output.exitstatus

    group_properties = {
      :name => group,
      :ensure => :present,
      :profider => self.name,
      :members => [],
      :groups => [],
    }

    output.each_line { |attr|
      group_properties[:members] << attr.gsub(/^\s+(\w+):User$/, '\1').chomp if /^\s+\w+:User$/ =~ attr
      group_properties[:groups] << attr.gsub(/^\s+(\w+):Group$/, '\1').chomp if /^\s+\w+:Group$/ =~ attr
    }

    group_properties
  end

  def self.instances
    get_mksgroup_list.collect do |group|
      group_properties = get_mksgroup_properties(group.chomp)
      new(group_properties) if group_properties
    end
  end

  def create
    @property_flush[:ensure] = :present
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def destroy
    @property_flush[:ensure] = :absent
  end

  def self.prefetch(resources)
    instances.each do |prov|
      if resource = resources[prov.name]
        resource.provider = prov
      end
    end
  end

  def get_mksgroup_command
    if @property_flush[:ensure] == :absent
      cmd = [ command(:integrity), 'deletemksdomaingroup',
        '--hostname=localhost',
        '--port=7001',
        '--user=fsaadmin',
        '--password=200MKS9',
        '--yes',
        "#{resource[:name]}" ]
      return cmd
    end

    unless @property_flush.empty?
      members = []
      members += resource[:members].collect {|i| 'u='+i} unless resource[:members].nil?
      members += resource[:groups].collect {|i| 'g='+i} unless resource[:groups].nil?
      cmd = [ command(:integrity), 'createmksdomaingroup',
        '--hostname=localhost',
        '--port=7001',
        '--user=fsaadmin',
        '--password=200MKS9',
        "--description=",
        "--name=#{resource[:name]}" ]
      cmd << "--members=#{members.join(',')}" unless members.empty?
    else
      properties = self.class.get_mksgroup_properties(resource[:name])
      add_members = (@property_hash[:members] - properties[:members]).collect {|i| 'u='+i}
      add_groups = (@property_hash[:groups] - properties[:groups]).collect {|i| 'g='+i}
      remove_members = (properties[:members] - @property_hash[:members]).collect {|i| 'u='+i}
      remove_groups = (properties[:groups] - @property_hash[:groups] - add_groups).collect {|i| 'g='+i}
      add = []
      add += add_members unless add_members.empty?
      add += add_groups unless add_groups.empty?
      remove = []
      remove += remove_members unless remove_members.empty?
      remove += remove_groups unless remove_groups.empty?
      cmd = [ command(:integrity), 'editmksdomaingroup',
        '--hostname=localhost',
        '--port=7001',
        '--user=fsaadmin',
        '--password=200MKS9',
        '--description=',
        '--yes' ]
      cmd << "--addMembers=#{add.join(',')}" unless add.empty?
      cmd << "--removeMembers=#{remove.join(',')}" unless remove.empty?
      cmd << "#{resource[:name]}"
    end

    cmd
  end

  def flush
    raw = Puppet::Util::Execution.execute(
      get_mksgroup_command,
      :failonfail => true,
      :uid => 'mks',
      :custom_environment => {
        'PATH' => '/opt/integrity/client/bin:/bin:/usr/bin',
        'MKS_IC_INSTANCE_DIR' => '/opt/integrity/client'
      })
  end

end
