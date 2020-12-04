#!/bin/sh

numb='810'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 3.2 --qblur 0.3 --qcomp 0.6 --vbv-init 0.0 --aq-mode 0 --b-adapt 0 --bframes 16 --crf 20 --keyint 290 --lookahead-threads 3 --min-keyint 25 --qp 50 --qpstep 3 --qpmin 2 --qpmax 68 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset placebo --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,3.0,1.6,1.1,3.2,0.3,0.6,0.0,0,0,16,20,290,3,25,50,3,2,68,28,2,2000,-1:-1,umh,show,placebo,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"