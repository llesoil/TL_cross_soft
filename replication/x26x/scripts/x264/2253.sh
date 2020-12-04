#!/bin/sh

numb='2254'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.4 --psy-rd 4.0 --qblur 0.5 --qcomp 0.7 --vbv-init 0.9 --aq-mode 3 --b-adapt 2 --bframes 10 --crf 0 --keyint 210 --lookahead-threads 2 --min-keyint 22 --qp 10 --qpstep 5 --qpmin 3 --qpmax 63 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset fast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,2.0,1.1,1.4,4.0,0.5,0.7,0.9,3,2,10,0,210,2,22,10,5,3,63,18,4,2000,-1:-1,umh,crop,fast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"