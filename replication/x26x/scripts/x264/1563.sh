#!/bin/sh

numb='1564'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 2.6 --qblur 0.4 --qcomp 0.6 --vbv-init 0.0 --aq-mode 3 --b-adapt 0 --bframes 10 --crf 0 --keyint 220 --lookahead-threads 3 --min-keyint 23 --qp 0 --qpstep 4 --qpmin 0 --qpmax 69 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset slower --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,2.0,1.1,1.1,2.6,0.4,0.6,0.0,3,0,10,0,220,3,23,0,4,0,69,28,3,2000,1:1,dia,show,slower,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"