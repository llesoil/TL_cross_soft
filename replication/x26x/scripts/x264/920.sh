#!/bin/sh

numb='921'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.0 --psy-rd 0.6 --qblur 0.3 --qcomp 0.9 --vbv-init 0.5 --aq-mode 2 --b-adapt 2 --bframes 6 --crf 40 --keyint 290 --lookahead-threads 2 --min-keyint 27 --qp 0 --qpstep 5 --qpmin 1 --qpmax 63 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset superfast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,1.5,1.3,1.0,0.6,0.3,0.9,0.5,2,2,6,40,290,2,27,0,5,1,63,18,3,1000,-1:-1,dia,show,superfast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"