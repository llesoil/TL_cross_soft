#!/bin/sh

numb='1503'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.3 --psy-rd 4.6 --qblur 0.6 --qcomp 0.7 --vbv-init 0.0 --aq-mode 0 --b-adapt 2 --bframes 10 --crf 20 --keyint 250 --lookahead-threads 2 --min-keyint 22 --qp 10 --qpstep 3 --qpmin 4 --qpmax 66 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset faster --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,1.5,1.3,1.3,4.6,0.6,0.7,0.0,0,2,10,20,250,2,22,10,3,4,66,18,1,2000,-2:-2,hex,crop,faster,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"