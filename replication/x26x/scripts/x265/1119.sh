#!/bin/sh

numb='1120'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 1.2 --qblur 0.6 --qcomp 0.6 --vbv-init 0.0 --aq-mode 3 --b-adapt 2 --bframes 12 --crf 0 --keyint 260 --lookahead-threads 2 --min-keyint 29 --qp 10 --qpstep 3 --qpmin 0 --qpmax 63 --rc-lookahead 28 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset slower --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,2.0,1.6,1.0,1.2,0.6,0.6,0.0,3,2,12,0,260,2,29,10,3,0,63,28,4,1000,-1:-1,umh,crop,slower,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"