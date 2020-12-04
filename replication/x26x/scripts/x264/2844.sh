#!/bin/sh

numb='2845'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.1 --pbratio 1.2 --psy-rd 4.8 --qblur 0.4 --qcomp 0.7 --vbv-init 0.6 --aq-mode 0 --b-adapt 1 --bframes 4 --crf 50 --keyint 210 --lookahead-threads 1 --min-keyint 30 --qp 30 --qpstep 4 --qpmin 4 --qpmax 67 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset veryfast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,0.0,1.1,1.2,4.8,0.4,0.7,0.6,0,1,4,50,210,1,30,30,4,4,67,48,6,2000,-1:-1,dia,crop,veryfast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"