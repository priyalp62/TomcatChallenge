
This is my submission for the first three steps of the Chef Tomcat Challenge described at https://learn.chef.io/modules/challenge-configure-tomcat#/ The cookbook has two recipes: default and server. Server contains all the meat.

Setup Summary:
	- Node: Centos 7 VM 
	- Workstation: Chef Development Kit Version: 2.3.4. I used Windows as my workstation, just to make it harder on myself.
	- Server: Hosted Chef

My cookbooks are at https://manage.chef.io/organizations/rstatsinger/cookbooks The tomcat cookbook version 0.1.0 is at https://manage.chef.io/organizations/rstatsinger/cookbooks/tomcat/0.1.0

I started this project knowing very little about Chef. The background work I did was as follows:

      1. Played with chef-solo for a while just to get a feel for things.

      2. Up on learn.chef.io I completed the Infrastruce Automation track and the following additional modules: Get Started with Test Kitchen, Go Beyond the Basics, and Test Driven Development with InSpec modules. I also found lots of help in the Chef docs, videos, and by just Googling the heck out of things when I had questions.

Implementation Notes:

Guards for idempotency to maintain Chef's 'test and repair' philosophy - I heavily researched Ruby methods for Etc and File - hopefully the expressions are behaving as I expect.

Tests - There is an extensive set of tests in test/smoke/default/default_test.rb

Templates - I generated templates for both the server.xml file and the tomcat.service file and I use :notifies to restart tomcat if they change. I also :subscribed the tomcat service to changes in these entities.

Attributes - I  defined a default attribute called tomcat-port in attributes/default.rb to make the port configurable and plugged it in with a Ruby expression in the server.xml template. I initially overrode it in the .kitchen.yml for testing purposes, as requested by the instructions.
cgnfgnfdgn
Kitchen - I kitchened the heck out of this thing. The value of TDD and spinning up local test kitchens is clear.

I got Foodcritic and CookStyle to see things my way, but not without some customization of .rubocop.yml :) There was a conflict between Foodcritic and the uploading of the tomcat cookbook. Foodcritic kept insisting that I specify 'depends tomcat' in the default recipe, but knife complained about a circular reference. See the discussion at https://github.com/Foodcritic/foodcritic/issues/242

Other notes:

VirtualBox 5.1 and Vagrant 2.0 were a recipe for 'kitchen create' failure. Vagrant 2 kept replacing the ssh keys and killing ssh access to the kitchen. Downgrading to VirtualBox 5 and Vagrant 1.8.4 solved the problem. The VirtualBox downgrade was required to maintain compatibility with the 
downgraded Vagrant

I have also placed the Users cookbook at https://github.com/rstatsinger/TomcatUsers. Initially I did most of the work for this cookbook in the tomcat cookbook but I've factored it out. The instructions did not specify any dependencies between the two cookbooks. I experimented with writing a wrapper cookbook for the two but I want to submit this project tonight. Time kills all deals.

