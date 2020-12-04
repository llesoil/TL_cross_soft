#!/bin/sh

numb='560'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.1 --psy-rd 2.0 --qblur 0.6 --qcomp 0.9 --vbv-init 0.9 --aq-mode 0 --b-adapt 2 --bframes 6 --crf 50 --keyint 300 --lookahead-threads 2 --min-keyint 23 --qp 10 --qpstep 5 --qpmin 3 --qpmax 64 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset veryfast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,3.0,1.2,1.1,2.0,0.6,0.9,0.9,0,2,6,50,300,2,23,10,5,3,64,28,1,2000,-1:-1,dia,crop,veryfast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"