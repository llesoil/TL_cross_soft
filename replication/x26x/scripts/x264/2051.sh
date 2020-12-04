#!/bin/sh

numb='2052'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.1 --psy-rd 1.6 --qblur 0.3 --qcomp 0.9 --vbv-init 0.2 --aq-mode 0 --b-adapt 0 --bframes 12 --crf 20 --keyint 220 --lookahead-threads 3 --min-keyint 29 --qp 50 --qpstep 3 --qpmin 0 --qpmax 64 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset fast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,2.0,1.5,1.1,1.6,0.3,0.9,0.2,0,0,12,20,220,3,29,50,3,0,64,38,3,1000,-1:-1,dia,crop,fast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"