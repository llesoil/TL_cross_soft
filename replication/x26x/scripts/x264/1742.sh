#!/bin/sh

numb='1743'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.1 --psy-rd 0.4 --qblur 0.3 --qcomp 0.7 --vbv-init 0.2 --aq-mode 2 --b-adapt 1 --bframes 6 --crf 40 --keyint 270 --lookahead-threads 0 --min-keyint 27 --qp 30 --qpstep 4 --qpmin 2 --qpmax 64 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset slower --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,3.0,1.3,1.1,0.4,0.3,0.7,0.2,2,1,6,40,270,0,27,30,4,2,64,18,6,1000,1:1,hex,show,slower,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"