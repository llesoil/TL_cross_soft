#!/bin/sh

numb='2008'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.4 --psy-rd 3.4 --qblur 0.4 --qcomp 0.9 --vbv-init 0.7 --aq-mode 2 --b-adapt 1 --bframes 8 --crf 45 --keyint 250 --lookahead-threads 2 --min-keyint 25 --qp 40 --qpstep 3 --qpmin 4 --qpmax 67 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset veryfast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,1.0,1.4,1.4,3.4,0.4,0.9,0.7,2,1,8,45,250,2,25,40,3,4,67,28,5,2000,-2:-2,hex,crop,veryfast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"