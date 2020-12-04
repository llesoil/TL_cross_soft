#!/bin/sh

numb='1233'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.1 --psy-rd 1.8 --qblur 0.6 --qcomp 0.7 --vbv-init 0.2 --aq-mode 1 --b-adapt 2 --bframes 4 --crf 5 --keyint 300 --lookahead-threads 1 --min-keyint 23 --qp 20 --qpstep 4 --qpmin 3 --qpmax 66 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset ultrafast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,0.5,1.5,1.1,1.8,0.6,0.7,0.2,1,2,4,5,300,1,23,20,4,3,66,18,6,1000,1:1,umh,crop,ultrafast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"