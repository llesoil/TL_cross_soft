#!/bin/sh

numb='2789'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.4 --psy-rd 3.8 --qblur 0.4 --qcomp 0.7 --vbv-init 0.3 --aq-mode 0 --b-adapt 1 --bframes 0 --crf 10 --keyint 280 --lookahead-threads 3 --min-keyint 30 --qp 10 --qpstep 5 --qpmin 3 --qpmax 69 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset superfast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,0.0,1.3,1.4,3.8,0.4,0.7,0.3,0,1,0,10,280,3,30,10,5,3,69,48,1,2000,-2:-2,hex,crop,superfast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"