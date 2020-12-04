#!/bin/sh

numb='3102'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.2 --psy-rd 3.8 --qblur 0.4 --qcomp 0.6 --vbv-init 0.4 --aq-mode 1 --b-adapt 2 --bframes 12 --crf 45 --keyint 200 --lookahead-threads 4 --min-keyint 24 --qp 20 --qpstep 4 --qpmin 3 --qpmax 63 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset slower --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,1.5,1.2,1.2,3.8,0.4,0.6,0.4,1,2,12,45,200,4,24,20,4,3,63,48,4,2000,-2:-2,umh,crop,slower,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"