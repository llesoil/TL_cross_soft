#!/bin/sh

numb='2714'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 0.2 --qblur 0.4 --qcomp 0.8 --vbv-init 0.1 --aq-mode 1 --b-adapt 0 --bframes 6 --crf 50 --keyint 300 --lookahead-threads 1 --min-keyint 25 --qp 40 --qpstep 5 --qpmin 4 --qpmax 69 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset slow --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,2.0,1.0,1.3,0.2,0.4,0.8,0.1,1,0,6,50,300,1,25,40,5,4,69,48,4,2000,-2:-2,hex,show,slow,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"