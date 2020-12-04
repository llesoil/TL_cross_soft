#!/bin/sh

numb='1618'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.1 --psy-rd 0.6 --qblur 0.5 --qcomp 0.7 --vbv-init 0.5 --aq-mode 1 --b-adapt 1 --bframes 12 --crf 10 --keyint 220 --lookahead-threads 0 --min-keyint 24 --qp 20 --qpstep 5 --qpmin 3 --qpmax 61 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset slow --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.0,1.5,1.1,0.6,0.5,0.7,0.5,1,1,12,10,220,0,24,20,5,3,61,28,1,1000,-1:-1,umh,crop,slow,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"