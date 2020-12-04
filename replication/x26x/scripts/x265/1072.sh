#!/bin/sh

numb='1073'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 3.0 --ipratio 1.4 --pbratio 1.4 --psy-rd 2.6 --qblur 0.6 --qcomp 0.9 --vbv-init 0.8 --aq-mode 1 --b-adapt 2 --bframes 0 --crf 5 --keyint 290 --lookahead-threads 2 --min-keyint 28 --qp 50 --qpstep 3 --qpmin 1 --qpmax 60 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset veryslow --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,3.0,1.4,1.4,2.6,0.6,0.9,0.8,1,2,0,5,290,2,28,50,3,1,60,48,2,1000,-1:-1,hex,crop,veryslow,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"