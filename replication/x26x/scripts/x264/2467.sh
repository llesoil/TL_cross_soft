#!/bin/sh

numb='2468'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.2 --psy-rd 4.2 --qblur 0.6 --qcomp 0.8 --vbv-init 0.1 --aq-mode 3 --b-adapt 0 --bframes 2 --crf 35 --keyint 250 --lookahead-threads 4 --min-keyint 28 --qp 30 --qpstep 3 --qpmin 4 --qpmax 60 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset veryfast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.0,1.2,1.2,4.2,0.6,0.8,0.1,3,0,2,35,250,4,28,30,3,4,60,38,4,1000,1:1,umh,show,veryfast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"