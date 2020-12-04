#!/bin/sh

numb='1283'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-weightb --aq-strength 2.0 --ipratio 1.4 --pbratio 1.3 --psy-rd 3.2 --qblur 0.6 --qcomp 0.7 --vbv-init 0.2 --aq-mode 0 --b-adapt 0 --bframes 16 --crf 40 --keyint 220 --lookahead-threads 0 --min-keyint 29 --qp 0 --qpstep 3 --qpmin 3 --qpmax 69 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset faster --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,2.0,1.4,1.3,3.2,0.6,0.7,0.2,0,0,16,40,220,0,29,0,3,3,69,28,6,2000,-1:-1,dia,crop,faster,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"