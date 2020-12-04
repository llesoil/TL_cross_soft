#!/bin/sh

numb='1959'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.0 --psy-rd 1.4 --qblur 0.4 --qcomp 0.7 --vbv-init 0.4 --aq-mode 3 --b-adapt 1 --bframes 8 --crf 0 --keyint 280 --lookahead-threads 0 --min-keyint 30 --qp 0 --qpstep 3 --qpmin 3 --qpmax 66 --rc-lookahead 28 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset fast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,2.5,1.4,1.0,1.4,0.4,0.7,0.4,3,1,8,0,280,0,30,0,3,3,66,28,4,1000,-2:-2,umh,crop,fast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"