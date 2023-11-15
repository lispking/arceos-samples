APP ?= hello_app

default:
	cd $(APP) && $(MAKE)	

clean:
	cd $(APP) && $(MAKE) clean
