
$oracle_server_config = {
  :default => {
    :tns => "(DESCRIPTION  =
             (ADDRESS_LIST  =
               (ADDRESS  =  
                 (PROTOCOL  =  TCP)
                 (HOST  =  61.139.76.161)
                 (PORT  =  1521))  )
             (CONNECT_DATA  =  (SID  = ORCL)))",
    :username => "ecen_kq",
    :password => "123456"
  },

  :test_expection => {
    :tns => "",
    :username => "ecen_kq",
    :password => "123456"
  }
}
  
$log_file_name = "#{File.dirname(__FILE__)}/../ao.log"


