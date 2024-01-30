$('.innerPanel').terminal({

  hello: function() {
    // Define the default variables with default values
    var $ip = '?.?.?.?'
    // Retrieve the user's IP address
    fetch('https://api.ipify.org/?format=json')
      .then(response => response.json())
      .then(data => {
        $ip = data.ip;
        if ($ip !== '?.?.?.?') {
          console.log($ip);
          this.echo('Hello, ' + $ip + '. Welcome to this terminal.');
        } else {
          console.log($ip);
          this.echo('Hello, ' + $ip + '. You have done well.');
        }
      });
  },

  whoami: function() {
    // Define the default variables with default values
    var $ip = '?.?.?.?'
    // Retrieve the user's IP address
    fetch('https://api.ipify.org/?format=json')
      .then(response => response.json())
      .then(data => {
        $ip = data.ip;
        if ($ip !== '?.?.?.?') {
          console.log($ip);
          this.echo($ip);
        } else {
          console.log($ip);
          this.echo($ip + 'Feeling lucky?');
        }
      });
  },

  sudo: function() {
    this.echo('Really?')
  },

  info: function() {
    var terminal = this;

    terminal.push(function(ps) {
      // Handle the user's input here
      if (ps === 'exit') {
        terminal.echo('Exiting the terminal...');
        terminal.pop();
      } else if (ps === 'password') {
        terminal.echo('Nice! Way to crack it!');
        terminal.pop();
      } else {
        terminal.echo(ps);
      }
    }, {
      prompt: 'Enter the password: '
    });
  },

  projects: function() {
    window.open('https://www.linkedin.com/in/raven-spencer-a0a558241/details/projects/')
  },

  linkedin: function() {
    window.open('https://www.linkedin.com/in/raven-spencer-a0a558241/')
  },

  certifications: function() {
    window.open('https://www.linkedin.com/in/raven-spencer-a0a558241/details/certifications/')
  },

  resume: function() {
    window.open('https://www.ravens-resume-crc.com/')
  },

// game: function() {
  
// }

whoisraven: function() {
  this.echo("Raven Spencer is a developer by trade and a cloud security professional by profession.\n\nHe finds himself desiring more knowledge by gaining hands-on skills to become an asset to any team in need of security, development, and automation.\n\nWhen he is not learning a new dev skill or posting about his learning he is out and active in his community or playing on his steam account.\n\nWhether he is playing the lastest games, hanging out with his families and friends, or pursuing the next step in his career, Raven is always an advocate for being genuine and gentle with others.\n\nDesiring to lead others to understanding and being excellent in all he does.\n");
}

}, {
  checkArity: false,
  completion: true,
  greetings: 'Terminal Booted',
  invokeMethods: true
  
});