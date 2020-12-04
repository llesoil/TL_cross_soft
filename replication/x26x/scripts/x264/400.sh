#!/bin/sh

numb='401'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.4 --psy-rd 3.4 --qblur 0.3 --qcomp 0.6 --vbv-init 0.9 --aq-mode 0 --b-adapt 0 --bframes 6 --crf 40 --keyint 200 --lookahead-threads 2 --min-keyint 21 --qp 30 --qpstep 4 --qpmin 0 --qpmax 62 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset veryfast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,3.0,1.5,1.4,3.4,0.3,0.6,0.9,0,0,6,40,200,2,21,30,4,0,62,38,4,2000,-1:-1,dia,crop,veryfast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"