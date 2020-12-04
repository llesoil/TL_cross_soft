#!/bin/sh

numb='2514'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 0.4 --qblur 0.3 --qcomp 0.7 --vbv-init 0.4 --aq-mode 3 --b-adapt 0 --bframes 2 --crf 10 --keyint 230 --lookahead-threads 2 --min-keyint 26 --qp 50 --qpstep 4 --qpmin 0 --qpmax 69 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset veryslow --scenecut 30 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.0,1.1,1.1,0.4,0.3,0.7,0.4,3,0,2,10,230,2,26,50,4,0,69,38,1,2000,-1:-1,hex,crop,veryslow,30,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"