#!/bin/sh

numb='929'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 0.2 --qblur 0.5 --qcomp 0.9 --vbv-init 0.5 --aq-mode 1 --b-adapt 2 --bframes 10 --crf 0 --keyint 230 --lookahead-threads 1 --min-keyint 29 --qp 30 --qpstep 4 --qpmin 0 --qpmax 65 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset slow --scenecut 40 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,None,--weightb,3.0,1.4,1.1,0.2,0.5,0.9,0.5,1,2,10,0,230,1,29,30,4,0,65,28,1,2000,-2:-2,umh,show,slow,40,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"