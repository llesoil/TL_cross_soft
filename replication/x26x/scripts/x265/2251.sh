#!/bin/sh

numb='2252'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 0.0 --ipratio 1.1 --pbratio 1.3 --psy-rd 3.8 --qblur 0.6 --qcomp 0.9 --vbv-init 0.2 --aq-mode 0 --b-adapt 1 --bframes 10 --crf 50 --keyint 280 --lookahead-threads 4 --min-keyint 21 --qp 40 --qpstep 3 --qpmin 1 --qpmax 63 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset veryslow --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,0.0,1.1,1.3,3.8,0.6,0.9,0.2,0,1,10,50,280,4,21,40,3,1,63,38,3,1000,-2:-2,hex,crop,veryslow,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"