export MAKEROOT := $(shell pwd)

include ./env.mk

#编译依第三方开源赖库
define build_dep
cd deps && make
endef


define build_obj
for SubDir in $(TARGET_DIRS); do \
    if ! [ -d $$SubDir ]; then \
        echo "The $$SubDir is not exist !"; \
        exit 11; \
    fi; \
    echo "Building $$SubDir ..."; \
    make -C $$SubDir ; \
    if [ $$? -ne 0 ]; then \
echo "Building $$SubDir is failed !"; \
        exit 12; \
    fi; \
done
endef

# 清除.depend
define del_obj
for SubDir in $(TARGET_DIRS); do \
    if ! [ -d $$SubDir ]; then \
        exit 11; \
    fi; \
    echo "Building $$SubDir ..."; \
    make -C $$SubDir clean; \
    if [ $$? -ne 0 ]; then \
        exit 12; \
    fi; \
done
endef


all:
	@$(call build_obj) #调用过程
	$(CXX) -o $(MAKEROOT)/bin/$(TARGET) $(MAKEROOT)/obj/*.o  $(LIB) $(LIB_DIR) #最终编译
depend:
	@$(call build_dep)

clean:
	-rm $(MAKEROOT)/obj/*.o  $(MAKEROOT)/bin/$(TARGET)
distclean:
	@$(call del_obj)
	-rm $(MAKEROOT)/obj/*.o  $(MAKEROOT)/bin/$(TARGET)