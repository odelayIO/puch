
all: clean 


clean:
	@rm -fr ip_user_files
	cd ./managed_ip_project && rm -rf *.cache *.hw *.runs *.sim && cd ../
	cd ./QPSK_Demod_Out_BRAM && cp QPSK_Demod_Out_BRAM.xci ../ && rm -fr * && mv ../QPSK_Demod_Out_BRAM.xci . && cd ../
	cd ./QPSK_Demodulator && cp QPSK_Demodulator.xci ../ && rm -fr * && mv ../QPSK_Demodulator.xci . && cd ../

.PHONY: all clean
