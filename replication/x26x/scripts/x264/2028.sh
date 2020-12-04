#!/bin/sh

numb='2029'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.0 --psy-rd 3.6 --qblur 0.3 --qcomp 0.6 --vbv-init 0.1 --aq-mode 0 --b-adapt 0 --bframes 10 --crf 10 --keyint 200 --lookahead-threads 1 --min-keyint 24 --qp 10 --qpstep 5 --qpmin 3 --qpmax 66 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset veryfast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,1.5,1.4,1.0,3.6,0.3,0.6,0.1,0,0,10,10,200,1,24,10,5,3,66,38,2,2000,-2:-2,dia,crop,veryfast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"