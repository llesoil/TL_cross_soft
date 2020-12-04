#!/bin/sh

numb='1500'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 0.8 --qblur 0.3 --qcomp 0.6 --vbv-init 0.7 --aq-mode 3 --b-adapt 2 --bframes 14 --crf 20 --keyint 290 --lookahead-threads 4 --min-keyint 23 --qp 50 --qpstep 5 --qpmin 3 --qpmax 65 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset ultrafast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,0.0,1.6,1.0,0.8,0.3,0.6,0.7,3,2,14,20,290,4,23,50,5,3,65,18,5,1000,-1:-1,hex,crop,ultrafast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"