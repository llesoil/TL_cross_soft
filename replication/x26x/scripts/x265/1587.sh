#!/bin/sh

numb='1588'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.2 --psy-rd 1.6 --qblur 0.6 --qcomp 0.9 --vbv-init 0.7 --aq-mode 1 --b-adapt 0 --bframes 10 --crf 45 --keyint 300 --lookahead-threads 0 --min-keyint 30 --qp 0 --qpstep 4 --qpmin 2 --qpmax 68 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan crop --preset veryslow --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,0.0,1.2,1.2,1.6,0.6,0.9,0.7,1,0,10,45,300,0,30,0,4,2,68,38,4,2000,1:1,hex,crop,veryslow,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"