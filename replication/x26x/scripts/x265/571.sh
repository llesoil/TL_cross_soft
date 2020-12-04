#!/bin/sh

numb='572'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-weightb --aq-strength 0.5 --ipratio 1.2 --pbratio 1.2 --psy-rd 2.0 --qblur 0.2 --qcomp 0.6 --vbv-init 0.3 --aq-mode 2 --b-adapt 2 --bframes 16 --crf 5 --keyint 240 --lookahead-threads 1 --min-keyint 28 --qp 50 --qpstep 4 --qpmin 3 --qpmax 66 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset veryfast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,0.5,1.2,1.2,2.0,0.2,0.6,0.3,2,2,16,5,240,1,28,50,4,3,66,18,3,2000,1:1,umh,show,veryfast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"