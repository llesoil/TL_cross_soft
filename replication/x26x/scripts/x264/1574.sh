#!/bin/sh

numb='1575'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.3 --psy-rd 3.8 --qblur 0.4 --qcomp 0.7 --vbv-init 0.8 --aq-mode 1 --b-adapt 1 --bframes 12 --crf 15 --keyint 240 --lookahead-threads 3 --min-keyint 22 --qp 40 --qpstep 5 --qpmin 3 --qpmax 63 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset superfast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,1.5,1.1,1.3,3.8,0.4,0.7,0.8,1,1,12,15,240,3,22,40,5,3,63,28,3,2000,-2:-2,hex,crop,superfast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"