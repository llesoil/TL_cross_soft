#!/bin/sh

numb='624'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 0.8 --qblur 0.5 --qcomp 0.9 --vbv-init 0.1 --aq-mode 1 --b-adapt 0 --bframes 16 --crf 10 --keyint 200 --lookahead-threads 1 --min-keyint 23 --qp 0 --qpstep 4 --qpmin 4 --qpmax 60 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset ultrafast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,3.0,1.1,1.1,0.8,0.5,0.9,0.1,1,0,16,10,200,1,23,0,4,4,60,18,3,2000,-2:-2,umh,crop,ultrafast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"