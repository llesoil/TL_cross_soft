#!/bin/sh

numb='2083'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 4.8 --qblur 0.5 --qcomp 0.7 --vbv-init 0.5 --aq-mode 3 --b-adapt 0 --bframes 4 --crf 10 --keyint 250 --lookahead-threads 4 --min-keyint 30 --qp 20 --qpstep 4 --qpmin 4 --qpmax 67 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset ultrafast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,0.0,1.0,1.3,4.8,0.5,0.7,0.5,3,0,4,10,250,4,30,20,4,4,67,18,4,1000,-1:-1,dia,crop,ultrafast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"