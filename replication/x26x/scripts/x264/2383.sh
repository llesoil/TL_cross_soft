#!/bin/sh

numb='2384'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.1 --psy-rd 3.4 --qblur 0.3 --qcomp 0.8 --vbv-init 0.2 --aq-mode 0 --b-adapt 0 --bframes 14 --crf 50 --keyint 250 --lookahead-threads 2 --min-keyint 26 --qp 10 --qpstep 3 --qpmin 4 --qpmax 67 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset slower --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.0,1.5,1.1,3.4,0.3,0.8,0.2,0,0,14,50,250,2,26,10,3,4,67,28,4,2000,-1:-1,dia,crop,slower,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"