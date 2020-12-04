#!/bin/sh

numb='1763'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.4 --psy-rd 1.8 --qblur 0.3 --qcomp 0.6 --vbv-init 0.2 --aq-mode 1 --b-adapt 2 --bframes 8 --crf 45 --keyint 250 --lookahead-threads 1 --min-keyint 23 --qp 0 --qpstep 3 --qpmin 3 --qpmax 62 --rc-lookahead 18 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset veryfast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,1.0,1.2,1.4,1.8,0.3,0.6,0.2,1,2,8,45,250,1,23,0,3,3,62,18,3,2000,-2:-2,umh,show,veryfast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"